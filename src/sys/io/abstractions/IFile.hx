package sys.io.abstractions;

import haxe.io.Input;
import haxe.io.Output;
import haxe.io.Bytes;

interface IFile
{
    function create(_path : String) : Void;

    function remove(_path : String) : Void;

    function exists(_path : String) : Bool;

    function read(_path : String) : Input;

    function write(_path : String) : Output;

    function writeText(_path : String, _text : String) : Void;

    function writeBytes(_path : String, _bytes : Bytes) : Void;

    function appendText(_path : String, _text : String) : Void;

    function appendBytes(_path : String, _bytes : Bytes) : Void;

    function getText(_path : String) : String;

    function getBytes(_path : String) : Bytes;
}
