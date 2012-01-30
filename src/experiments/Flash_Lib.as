package experiments {

import flash.display.Sprite;
import flash.text.TextField;

public class Flash_Lib extends Sprite
{
    public function Flash_Lib()
    {
        var textField:TextField = new TextField();
        textField.text = "Hello, World";
        addChild(textField);
    }
}
}
