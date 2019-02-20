package sys.io.abstractions;

interface IDirectory
{
    function create(_path : String) : Void;

    function remove(_path : String) : Void;

    function exist(_path : String) : Bool;

    function read(_path : String) : Array<String>;

    function isDirectory(_path : String) : Bool;
}
