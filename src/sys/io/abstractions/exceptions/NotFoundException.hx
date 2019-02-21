package sys.io.abstractions.exceptions;

import haxe.Exception;

class NotFoundException extends Exception
{
    public function new(_message : String)
    {
        super(_message);
    }
}
