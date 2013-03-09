package {
import flash.display.*;
import flash.geom.ColorTransform;
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

    private var xVelocityComponent:Number;
    private var yVelocityComponent:Number;

    protected var body: Shape;

    public function Protostar( x,y,dx,dy,radius ) {

        this.radius = radius;
        //velocityModulus = 5.0;
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

    public function rotateToPointer ( pointerX:Number,  pointerY:Number){

        var dx:Number = pointerX - body.x;
        var dy:Number = pointerY - body.y;

        // определить угол
        var cursorAngle:Number = Math.atan2(dy,dx);

        var xNormalizedAccelerationComponent:Number = Math.cos(cursorAngle);
        var yNormalizedAccelerationComponent:Number = Math.sin(cursorAngle);

        var correction:Number = 500/radius;

        xVelocityComponent += xNormalizedAccelerationComponent*correction;
        yVelocityComponent += yNormalizedAccelerationComponent*correction;

    }


    public function getRadius() :Number {
        return radius;
    }

    // Увеличить площадь объекта на deltaSquare
    public function changeSquare( deltaSquare:Number) {
        radius = Math.sqrt((square() + deltaSquare)/Math.PI);
        //redraw( 0x00FF00 );
    }

    // Уменьшить радиус на deltaRadius и
    // получить площадь, на которую уменьшился объект
    public function changeRadius( deltaRadius: Number): Number {
        var oldSquare:Number = square();
        radius -= deltaRadius;

        return oldSquare - square();

    }


    // Перерисовать
    public function redraw( rgbColor1:Vector.<uint>,
                            rgbColorMiddle:Vector.<uint>,
                            rgbColor2:Vector.<uint>,
                            minRadius:Number,
                            playerRadius:Number,
                            maxRadius:Number ){

        body.graphics.clear();
        body.graphics.beginFill( 0x000000 , 1 );
        body.graphics.drawCircle( 0, 0, radius );

        var normalized:Number;
        if ( minRadius == maxRadius ) {
            normalized = 0.5;
        } else {
            normalized = ( radius - minRadius ) / ( maxRadius - minRadius );
        }

        var rgbColor:Vector.<uint> = new <uint> [
            uint(normalized * (rgbColor2[0] - rgbColor1[0] ) + rgbColor1[0]),
            uint(normalized * (rgbColor2[1] - rgbColor1[1] ) + rgbColor1[1]),
            uint(normalized * (rgbColor2[2] - rgbColor1[2] ) + rgbColor1[2])
        ];


        //var rOffset:Number = transform.colorTransform.redOffset + 1;
        //var bOffset:Number = transform.colorTransform.redOffset - 1;
        this.transform.colorTransform = new ColorTransform(0,0,0,1, rgbColor[0], rgbColor[1], rgbColor[2], 0);

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


    // Проверка соприкосновений
    public function collision( another: Protostar ) :int {
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
    public function square():Number{
        return Math.PI * radius * radius;
    }

}

}
