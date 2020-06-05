package sys.io.abstractions;

import haxe.io.Input;
import haxe.io.Output;
import haxe.io.Bytes;

/**
 * Interface for file operations.
 * Provides functions for creating, removing, checking, reading, writing, and streaming data to and from files.
 */
interface IFile
{
    /**
     * Create a file if it does not exist.
     * @param _path File to create.
     * @throws ArgumentException If the provided path if whitespace.
     */
    function create(_path : String) : Void;

    /**
     * Removes a file from the hard drive.
     * @param _path File to remove.
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist.
     */
    function remove(_path : String) : Void;

    /**
     * Checks if a file exists.
     * @param _path File to check.
     * @return Bool
     */
    function exists(_path : String) : Bool;

    /**
     * Provides a `haxe.io.Input` stream to read data from a file.
     * @param _path File to read.
     * @return Input
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist.
     */
    function read(_path : String) : Input;

    /**
     * Provides a `haxe.io.Output` stream to write data to a file.
     * `close` must be called on the stream to ensure data is flushed.
     * @param _path File to write to.
     * @return Output
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist.
     */
    function write(_path : String) : Output;

    /**
     * Replaces the contents of a file with the provided string.
     * @param _path File to write to.
     * @param _text String for the file.
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist.
     */
    function writeText(_path : String, _text : String) : Void;

    /**
     * Replaces the contents of a file with the provided bytes.
     * @param _path File to write to.
     * @param _bytes Bytes for the file.
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist. 
     */
    function writeBytes(_path : String, _bytes : Bytes) : Void;

    /**
     * Appends a string to the end of a file.
     * @param _path File to append to.
     * @param _text String to append.
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist. 
     */
    function appendText(_path : String, _text : String) : Void;

    /**
     * Appends bytes to the end of a file.
     * @param _path File to append to.
     * @param _bytes Bytes to append.
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist. 
     */
    function appendBytes(_path : String, _bytes : Bytes) : Void;

    /**
     * Get a string representation of a files contents.
     * @param _path File to read.
     * @return String
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist. 
     */
    function getText(_path : String) : String;

    /**
     * Gets the raw bytes of a file.
     * @param _path File to read.
     * @return Bytes
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist. 
     */
    function getBytes(_path : String) : Bytes;

    /**
     * Move a file to another location.
     * @param _src File to move.
     * @param _dst Destination to copy to.
     * @throws ArgumentException If the provided path is whitespace.
     * @throws NotFoundException If the source file does not exist.
     */
    function move(_src : String, _dst : String) : Void;

    /**
     * Copy the contents of a file to another file.
     * @param _src File to read from.
     * @param _dst File to copy to.
     * @throws ArgumentException If the provided path is whitespace.
     * @throws NotFoundException If the source file does not exist.
     */
    function copy(_src : String, _dst : String) : Void;
}
