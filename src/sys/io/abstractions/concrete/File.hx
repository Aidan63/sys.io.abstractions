package sys.io.abstractions.concrete;

import haxe.io.Bytes;
import haxe.io.Input;
import haxe.io.Output;
import sys.io.abstractions.exceptions.ArgumentException;
import sys.io.abstractions.exceptions.NotFoundException;

using StringTools;

/**
 * Concrete file implementation, operates of files on the actual file system.
 */
class File implements IFile
{
    public function new()
    {
        //
    }

    /**
     * Create a file if it does not exist.
     * @param _path File to create.
     * @throws ArgumentException If the provided path if whitespace.
     */
    public function create(_path : String)
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!sys.FileSystem.exists(_path))
        {
            sys.io.File.saveContent(_path, '');
        }
    }

    /**
     * Removes a file from the hard drive.
     * @param _path File to remove.
     * @throws ArgumentException If the provided path if whitespace.
     */
    public function remove(_path : String)
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        sys.FileSystem.deleteFile(_path);
    }

    /**
     * Checks if a file exists.
     * @param _path File to check.
     * @return Bool
     */
    public function exists(_path : String) : Bool
    {
        return sys.FileSystem.exists(_path);
    }

    /**
     * Provides a `haxe.io.Input` stream to read data from a file.
     * @param _path File to read.
     * @return Input
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist.
     */
    public function read(_path : String) : Input
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!sys.FileSystem.exists(_path))
        {
            throw new NotFoundException('${_path} not found');
        }

        return sys.io.File.read(_path);
    }

    /**
     * Provides a `haxe.io.Output` stream to write data to a file.
     * `close` must be called on the stream to ensure data is flushed.
     * @param _path File to write to.
     * @return Output
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist.
     */
    public function write(_path : String) : Output
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!sys.FileSystem.exists(_path))
        {
            throw new NotFoundException('${_path} not found');
        }

        return sys.io.File.write(_path);
    }

    /**
     * Replaces the contents of a file with the provided string.
     * @param _path File to write to.
     * @param _text String for the file.
     * @throws ArgumentException If the provided path if whitespace.
     */
    public function writeText(_path : String, _text : String)
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        sys.io.File.saveContent(_path, _text);
    }

    /**
     * Replaces the contents of a file with the provided bytes.
     * @param _path File to write to.
     * @param _bytes Bytes for the file.
     * @throws ArgumentException If the provided path if whitespace.
     */
    public function writeBytes(_path : String, _bytes : Bytes)
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        sys.io.File.saveBytes(_path, _bytes);
    }

    /**
     * Appends a string to the end of a file.
     * @param _path File to append to.
     * @param _text String to append.
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist. 
     */
    public function appendText(_path : String, _text : String)
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!sys.FileSystem.exists(_path))
        {
            throw new NotFoundException('${_path} not found');
        }

        var out = sys.io.File.append(_path, false);
        out.writeString(_text);
        out.close();
    }

    /**
     * Appends bytes to the end of a file.
     * @param _path File to append to.
     * @param _bytes Bytes to append.
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist. 
     */
    public function appendBytes(_path : String, _bytes : Bytes)
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!sys.FileSystem.exists(_path))
        {
            throw new NotFoundException('${_path} not found');
        }

        var out = sys.io.File.append(_path);
        out.writeBytes(_bytes, 0, _bytes.length);
        out.close();
    }

    /**
     * Get a string representation of a files contents.
     * @param _path File to read.
     * @return String
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist. 
     */
    public function getText(_path : String) : String
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!sys.FileSystem.exists(_path))
        {
            throw new NotFoundException('${_path} not found');
        }

        return sys.io.File.getContent(_path);
    }

    /**
     * Gets the raw bytes of a file.
     * @param _path File to read.
     * @return Bytes
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the file does not exist. 
     */
    public function getBytes(_path : String) : Bytes
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!sys.FileSystem.exists(_path))
        {
            throw new NotFoundException('${_path} not found');
        }

        return sys.io.File.getBytes(_path);
    }

    /**
     * Move a file to another location.
     * @param _src File to move.
     * @param _dst Destination to copy to.
     * @throws ArgumentException If the provided path is whitespace.
     * @throws NotFoundException If the source file does not exist.
     */
    public function move(_src : String, _dst : String)
    {
        if (_src.trim().length == 0)
        {
            throw new ArgumentException('Source path is only whitespace');
        }
        if (_dst.trim().length == 0)
        {
            throw new ArgumentException('Destination path is only whitespace');
        }

        if (!sys.FileSystem.exists(_src))
        {
            throw new NotFoundException('$_src not found');
        }

        sys.io.File.copy(_src, _dst);
        sys.FileSystem.deleteFile(_src);
    }

    /**
     * Copy the contents of a file to another file.
     * @param _src File to read from.
     * @param _dst File to copy to.
     * @throws ArgumentException If the provided path is whitespace.
     * @throws NotFoundException If the source file does not exist.
     */
    public function copy(_src : String, _dst : String)
    {
        if (_src.trim().length == 0)
        {
            throw new ArgumentException('Source path is only whitespace');
        }
        if (_dst.trim().length == 0)
        {
            throw new ArgumentException('Destination path is only whitespace');
        }

        if (!sys.FileSystem.exists(_src))
        {
            throw new NotFoundException('$_src not found');
        }

        sys.io.File.copy(_src, _dst);
        sys.FileSystem.deleteFile(_src);
    }
}
