package hoplaa
{
    import mx.core.WindowedApplication;
    import mx.controls.SWFLoader;
   
    public class AS2AIR extends WindowedApplication
    {
        public var swf:SWFLoader;
       
            public function init():void
            {
                this.swf.source = "My_Old_AS2_Code.swf";
            }
    }
}