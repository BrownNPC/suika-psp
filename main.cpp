#include <QuickGame.hpp>
#include <iostream>
#include <pspctrl.h>

#include <chipmunk.hpp>


// using namespace QuickGame; // game library

namespace gameObjects {
     //math stuff
    double clamp(double value, double min, double max){
        return std::max(min, std::min(value, max));
    }
    using namespace cp;


    struct Fruit_properties
    {
        QGVector2 size;
        f32 radius;
        int points;
        const char* spritepath;
    };

    struct magic_nums
    {
        // divided by 2.6 because we're scaling down magic nums from a python version of this game
        // https://github.com/Ole-Batting/suika

        // CHIPMUNK MAGIC NUMS
        const cpVect gravity = cpv(0,-600/2.6);
        const cpFloat damping = 0.8/2.6;
        const cpFloat bias = 0.00001;
        const cpFloat wall_friction = 10/2.6;
        const cpFloat fruit_friction = 0.4;    
        const QGVector2 next_fruit_bubble_pos = {480-73, 270-68};

    };
    magic_nums nums;
    // for handling cloud movement and also the white line below it.
    class Cloud {
        public:
        //if not going out of bounds, then move
        void move_left(double dt, QGTransform2D &transform){
            transform.position.x = clamp(wleft, transform.position.x - dt * 200 , transform.position.x);
            line.position.x = transform.position.x - 15;
        };
        void move_right(double dt, QGTransform2D &transform){
            transform.position.x= clamp(transform.position.x + dt * 200, transform.position.x, wright);
            line.position.x = transform.position.x - 15;
        };
        void draw_line(){
            QuickGame_Primitive_Draw_Rectangle(line, white);
        }
        // allow user to pass different wall args for future changes without touching this class
        Cloud(int wall_left, int wall_right ){  
            wleft = wall_left, wright = wall_right;
        };
        
        private:
        double wleft, wright; //wall bounds and deltaTime
        //line
        QGTransform2D line = {.position = {480/2 - 15, 130 },.scale = {2,192}};
        QGColor white = {.rgba={255,255,255,90}};
        };

    class Fruit {
        public:
        std::shared_ptr<Body> body;
        std::shared_ptr<CircleShape> shape;
        int id; // 0=cherry, 10=watermelon
        Fruit(float radius, int id, cpVect position){
            // body = cpSpaceAddBody(space, cpBodyNew(5, cpMomentForCircle(100, 0, 10, cpvzero)));
            body = std::make_shared<Body>(1, momentForCircle(1, 0, 10, Vect()));
            // space.add(body);
            body->setPosition(position);
            // shape = cpSpaceAddShape(space, cpCircleShapeNew(body, fruits[id].radius, cpvzero));
            shape = std::make_shared<CircleShape>(body, radius, Vect());
            shape->setFriction(nums.fruit_friction);
            // body->setUserData()

            

            this->id = id;
            // space.add(shape);
        };

        QGTransform2D get_transform(){
            QGTransform2D transform = {.rotation = 0};
            
            
            transform.position.x = body->getPosition().x; transform.position.y = body->getPosition().y;
            transform.rotation += (body->getPosition().x) * -4.0;
            return transform;
        };
    };

    class FruitContainer {
        // handles spawning fruits, their sprite intialization, collisions, detects gameovers.
        private:

        Space space;
        int next_fruit = (rand() % 5); // random number 0 through 4, used for spawning new fruits
        int current_fruit = (rand() % 5); // only the first 5 fruits are default spawnable

        // QGTransform2D shape_transform = {.scale = {.x = radius, .y = radius}};
        QGColor white = {.rgba={255,255,255,255}};
        
        QGSprite_t fruit_sprites[10]; // we can combine them with chipmunk bodies in draw_fruits()
        std::vector<Fruit_properties> fruits ;  // fruit properties (radius, size, points) creating array of fruit structs
        std::vector<Fruit> spawned_fruits;
        double fruit_radii[11];
        void initialize_fruit_properties(){
            //FRUIT MAGIC NUMS
            // cherry
            fruits.push_back({.size={40/2.6, 40/2.6},   .points= 1, .spritepath="assets/sprites/fruit/cherry.png"});
            // strawberry
            fruits.push_back({.size={40/2.6, 43/2.6},   .points= 3, .spritepath="assets/sprites/fruit/strawberry.png"});
            // grapes
            fruits.push_back({.size={62/2.6, 56/2.6},   .points= 6, .spritepath="assets/sprites/fruit/grapes.png"});
            // dekopon
            fruits.push_back({.size={72/2.6, 69/2.6},   .points= 10,.spritepath="assets/sprites/fruit/dekopon.png"});
            // orange
            fruits.push_back({.size={88/2.6, 96/2.6},   .points= 15,.spritepath="assets/sprites/fruit/orange.png"});
            // apple
            fruits.push_back({.size={112/2.6, 112/2.6}, .points= 21,.spritepath="assets/sprites/fruit/apple.png"});
            // pear
            fruits.push_back({.size={130/2.6, 130/2.6}, .points= 28,.spritepath="assets/sprites/fruit/pear.png"});
            // peach
            fruits.push_back({.size={156/2.6, 156/2.6}, .points= 36,.spritepath="assets/sprites/fruit/peach.png"});
            // pineapple
            fruits.push_back({.size={175/2.6, 200/2.6}, .points= 45,.spritepath="assets/sprites/fruit/pineapple.png"});
            // melon
            fruits.push_back({.size={250/2.6, 220/2.6},.points= 55,.spritepath="assets/sprites/fruit/melon.png"});
            // watermelon
            fruits.push_back({.size={250/2.6, 250/2.6},.points= 66,.spritepath="assets/sprites/fruit/watermelon.png"});
            
            
            fruit_radii[0]= 17.0/2.6;
            fruit_radii[1]= 21.0/2.6;
            fruit_radii[2]= 29.0/2.6;
            fruit_radii[3]= 35.0/2.6;
            fruit_radii[4]= 45.0/2.6;
            fruit_radii[5]= 56.0/2.6;
            fruit_radii[6]= 65.0/2.6;
            fruit_radii[7]= 78.0/2.6;
            fruit_radii[8]= 87.0/2.6;
            fruit_radii[9]= 109.0/2.6;
            fruit_radii[10]= 125.0/2.6;
        };
        void initialize_container_boundaries(){
            space.setGravity(nums.gravity);
            
            // create container walls and ground
            auto ground = std::make_shared<SegmentShape>(space.staticBody, Vect(0, 272/2-117), Vect(480, 272/2-117), 0);
            auto wallL = std::make_shared<SegmentShape>(space.staticBody, Vect(480/2-84, 0), Vect(480/2-84, 272), 0);
            auto wallR = std::make_shared<SegmentShape>(space.staticBody, Vect(480/2+84, 0), Vect(480/2+84, 272), 0);
            
            space.add(ground);
            space.add(wallL);
            space.add(wallR);
            ground->setFriction(nums.wall_friction);
            wallL->setFriction(nums.wall_friction);
            wallR->setFriction(nums.wall_friction);
        };
        void initialize_fruit_sprites(){
            // load texture, create sprite, add sprite to fruit_sprites[]
            for (size_t i = 0; i < 11; i++)
            {
            QGTexInfo texture = {.filename = fruits.at(i).spritepath , 1,1};
            fruit_sprites[i]=QuickGame_Sprite_Create_Contained(480/2,272/2,fruits.at(i).size.x,fruits.at(i).size.y, texture);
            }
        
        };
        
        public:
        FruitContainer(){
            initialize_container_boundaries();
            initialize_fruit_properties();
            initialize_fruit_sprites();
            // cp::Space::addCollisionHandler(,)
        };

        void step_physics(double deltaTime){
            // if running at less than 30 fps, set physics to run at 30 fps
            cpSpaceStep(space, deltaTime);

        };
        void draw_fruits(QGVector2 cloud_position){
            // current fruit that is held by cloud
            fruit_sprites[current_fruit]->transform.position.x = cloud_position.x-15;
            fruit_sprites[current_fruit]->transform.position.y = cloud_position.y-15;
            fruit_sprites[current_fruit]->transform.rotation = (cloud_position.x-15) * -4.0 ;
            QuickGame_Sprite_Draw(fruit_sprites[current_fruit]); // draw current fruit held by cloud
            fruit_sprites[current_fruit]->transform.rotation = 0; // reset rotation after showing current fruit
            
            // draw next fruit inside bubble
            fruit_sprites[next_fruit]->transform.position = nums.next_fruit_bubble_pos;
            QuickGame_Sprite_Draw(fruit_sprites[next_fruit]);
            

            for (size_t i = 0; i < spawned_fruits.size(); i++)
            {   
                auto fruit = spawned_fruits[i];
                auto transform = fruit.get_transform();
                fruit_sprites[fruit.id]->transform.position = transform.position;
                fruit_sprites[fruit.id]->transform.rotation = transform.rotation;
                QuickGame_Sprite_Draw(fruit_sprites[fruit.id]);
            }

            
        };  

        void spawn_fruit(cpVect cloud_position){
            
            Fruit newfruit ( fruit_radii[current_fruit], current_fruit, cloud_position);
            spawned_fruits.push_back(newfruit);
            space.add(newfruit.body);
            space.add(newfruit.shape);
            // TODO: Only do this when the new fruit has collided with another fruit or wall
            current_fruit = next_fruit;
            next_fruit = rand() % 5;
        };
    };

};

namespace gameWorld {
    using QuickGame::Graphics::Sprite;
    /*
    This namespace handles all game events like physics, movement, spawning fruits etc. 
    We first initilize sprites and movement handlers, then change the update function which is run every frame.
    */
    // load backdrop 
    QGTexInfo bgtexinfo = {.filename="./assets/sprites/background.png", .flip = true, .vram = false};    
    Sprite bg( {480/2, 272/2}, {480,272}, bgtexinfo);        
    // load cloud sprite
    QGTexInfo cloudtexinfo = {.filename = "assets/sprites/cloud/cloud.png", 1,0};
    Sprite cloud_spr( {240,250}, {48,48}, cloudtexinfo);
    // cloud movement controller
    gameObjects::Cloud cloud( 180, 330); //wall left, wall right
    
    // array of fruit sprites
    gameObjects::FruitContainer fruit_container;
    void update(double dt){
        QuickGame_Input_Update();

        // Cloud movement
        if (QuickGame_Button_Held(PSP_CTRL_LEFT) or QuickGame_Analog_X() < -0.35) {
            cloud.move_left(dt, cloud_spr.transform);
        }
        if (QuickGame_Button_Held(PSP_CTRL_RIGHT) or QuickGame_Analog_X() > 0.35)
        {
            cloud.move_right(dt,cloud_spr.transform);
            
        }
        
        // fruit spawning
        if (QuickGame_Button_Pressed(PSP_CTRL_CROSS)){
            auto pos = cloud_spr.transform.position;
            fruit_container.spawn_fruit(cpVect {pos.x-15, pos.y-15});
            // create new fruit 
            // add it to the pool of spawned fruits
            //TODO: only spawn new fruits when the previoud fruit has touched another body

        };
        fruit_container.step_physics(dt);
    };

    void draw(){
        QuickGame::Graphics::start_frame();
        QuickGame::Graphics::clear(); 

        bg.draw();
        cloud_spr.draw();
        cloud.draw_line();
        fruit_container.draw_fruits(cloud_spr.transform.position);


        

        QuickGame::Graphics::end_frame(true);
    };
}

QGTimer timer;
int main(int argc, char** argv){
    QuickGame::init(); // initialize graphics engine
    QuickGame::Graphics::set2D();

    QuickGame_Timer_Start(&timer);
    srand(time(NULL)); // init random number generator

    while (QuickGame::running()) // main game loop
    {
        gameWorld::update(QuickGame_Timer_Delta(&timer)); // using seperate namespace for handling all game events == cleaner code
        gameWorld::draw(); 


    }
    return 0 ;
};

