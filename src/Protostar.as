package {
import flash.display.*;
import flash.geom.Point;
import flash.geom.Rectangle;

public class Protostar extends Sprite {

    // Радиус скорости
    public var radius:Number;

    // Модуль скорости
    private var velocityModulus:Number;

    // Нормализованные x и y составляющие вектора скорости
    // Определяют текущее направление движения
    private var xNormalizedVelocityComponent:Number;
    private var yNormalizedVelocityComponent:Number;

    protected var xVelocityComponent:Number;
    protected var yVelocityComponent:Number;

    protected var body: Shape;

    public function Protostar( x,y,dx,dy,radius ) {

        this.radius = radius;

        xVelocityComponent = dx;
        yVelocityComponent = dy;

        body = new Shape();

        body.graphics.beginFill(0xFF0000, 1);
        body.graphics.drawCircle(0,0,radius);

        body.x = x;
        body.y = y;

        addChild(body);
    }

    public function move (environmentalResistanceCoefficient:Number, timeCorrection :Number){

        xVelocityComponent *= environmentalResistanceCoefficient;
        yVelocityComponent *= environmentalResistanceCoefficient;

        if ( Math.abs(xVelocityComponent) < 0.09 ) xVelocityComponent = 0;
        if ( Math.abs(yVelocityComponent) < 0.09 ) yVelocityComponent = 0;

        body.x += xVelocityComponent * timeCorrection ;
        body.y += yVelocityComponent * timeCorrection ;

    }




    public function getRadius() :Number {
        return radius;
    }

    // Увеличить площадь объекта на deltaSquare
    public function changeSquare( deltaSquare:Number) {
        radius = Math.sqrt((getSquare() + deltaSquare)/Math.PI);
        //redraw( 0x00FF00 );
    }

    // Уменьшить радиус на deltaRadius и
    // получить площадь, на которую уменьшился объект
    public function changeRadius( deltaRadius: Number): Number {
        var oldSquare:Number = getSquare();
        radius -= deltaRadius;

        return oldSquare - getSquare();

    }



    // Получение центра
    public function getCenter() :Point {
        return new Point( body.x, body.y );
    }

    // Проверка столкновений со стенками
    public function collisionEdges( edges: Rectangle ) {

        if ( body.y - radius < edges.top ) {
            yVelocityComponent*=-1; // изменение направления
            body.y = 2 * edges.top - body.y + 2 * radius ; // расчет моментального отражения
        }

        if ( body.y + radius > edges.bottom ) {
            yVelocityComponent*=-1;  // изменение направления
            body.y = 2 * edges.bottom - body.y - 2 * radius;
        }

        if ( body.x - radius < edges.left ) {
            xVelocityComponent*=-1; // изменение направления
            body.x = 2 * edges.left - body.x + 2 * radius ; // расчет моментального отражения
        }

        if ( body.x + radius > edges.right ) {
            xVelocityComponent*=-1;  // изменение направления
            body.x = 2 * edges.right - body.x - 2 * radius;
        }
    }


    // Проверка поглощений
    public function absorption( another: Protostar ) :int {
        // Расстояние между центрами
        var distance:Number = Point.distance( getCenter(), another.getCenter());
        var radiusSum:Number = radius + another.getRadius();

        if ( distance < radiusSum ) {
           if (radius >= another.radius){
               changeSquare( another.changeRadius( radiusSum - distance ) );
           } else {
               another.changeSquare( changeRadius( radiusSum - distance ) );
           }

            if ( another.getRadius() <= 0.0){
               return 2;  // 2ой уничтожен
            }
            if ( radius <= 0.0){
             return 1; // текущий уничтожен
            }
            return 0;
        }
        return -1; // ничего не произошло
    }

    // Возвращает площадь
    public function getSquare():Number{
        return Math.PI * radius * radius;
    }

}

}
