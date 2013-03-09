package {

import flash.display.Sprite;
import flash.events.Event;
import flash.utils.getTimer;
import flash.text.TextField;

public class Protocluster extends Sprite {

    var currentGalaxy: Protogalaxy
    public var startTime:Number;
    public var framesNumber:Number = 0;
    public var fps:TextField = new TextField();

    public function Protocluster() {

        var myObj:Object = new Object();
        myObj.user = new Object();
        myObj.enemy = new Object();
        myObj.user.color = [0,255,255];
        myObj.enemy.color1 = [255,0,0];
        myObj.enemy.color2 = [0,255,0];

//        myObj.enemy = new Object();
//        myObj.mycolor = 0xff0000;
//        myObj.mytext = "мой текст";
        /*
         преобразуем ассоциативный массив в JSON-формат
         */
        //var json:String = "{\"user\": {"color": [r, g, b]}, enemy: {color1: [r, g, b], color2: [r, g, b]}}";
        //var json:String = "{\"user\": {"color": [r, g, b]}, "enemy": {"color1": [r, g, b], "color2": [r, g, b]}}";
        //var json:String = "{\"user\": [r, g, b]}";
        var json:String = JSON.stringify(myObj);
        // {"mywidth":300,"mycolor":16711680,"mytext":"РјРѕР№ С‚РµРєСЃС‚","myheight":200}
        /*
         выводим результат
         */
        trace("JSON: " + json)
        /*
         превращаем JSON-строку в ассоциативный массив
         */
        var obj:Object = JSON.parse(json);
        /*
         с помощью цикла for in перебираем массив, выводя имена свойств и их значения
         */
        for (var prop:String in obj) {
            trace("Prop: " + prop + " Value: " + obj[prop]) ;
        }

        var json_in = JSON.parse(json, function(k,v) {
                    if ("user" in v) { // special marker tag from stringify() replacer code
                        // Retrieve the original object based on the ID stored in the stringify() replacer function.
                        trace( v["user"] );
                        var contents = v["user"];
                        for (var i in contents) {
                            // Reviving JSONGenericDictExample objects from string
                            // identifiers is also special;
                            // see JSONGenericDictExample constructor and
                            // JSONGenericDictExample's revive() method.
                            trace( i + " " + contents[i] );
                        }
                    }
                    if ("enemy" in v){
                        var contents = v["enemy"];
                        for (var i in contents) {
                            trace( contents[i] );
                        }
                    }
                    return v;
                }
        );

        currentGalaxy = new Protogalaxy();

        addChild(currentGalaxy);

        fpsCounter();
    }


    // Счетчик FPS
    private function fpsCounter():void
    {
        startTime = getTimer();
        addChild(fps);

        addEventListener(Event.ENTER_FRAME, checkFPS);
    }

    private function checkFPS(e:Event):void
    {
        var currentTime:Number = (getTimer() - startTime) / 1000;

        framesNumber++;

        if (currentTime > 1)
        {
            fps.text = "FPS: " + (Math.floor((framesNumber/currentTime)*10.0)/10.0);
            startTime = getTimer();
            framesNumber = 0;
        }
    }

}
}
