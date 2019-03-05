package sys.io.abstractions.concrete;

import haxe.io.Bytes;
import haxe.io.Input;
import haxe.io.Output;
import sys.io.abstractions.exceptions.ArgumentException;
import sys.io.abstractions.exceptions.NotFoundException;

using StringTools;

/**
 * //
 */
class File implements IFile
{
    public function new()
    {
        //
    }

    /**
     * //
     * @param _path //
     */
    public function create(_path : String)
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        sys.io.File.saveContent(_path, '');
    }

    /**
     * //
     * @param _path //
     */
    public function remove(_path : String)
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!sys.FileSystem.exists(_path))
        {
            throw new NotFoundException('${_path} not found');
        }

        sys.FileSystem.deleteFile(_path);
    }

    /**
     * //
     * @param _path //
     * @return Bool
     */
    public function exists(_path : String) : Bool
    {
        return sys.FileSystem.exists(_path);
    }

    /**
     * //
     * @param _path //
     * @return Input
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
     * //
     * @param _path //
     * @return Output
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
     * //
     * @param _path //
     * @param _text //
     */
    public function writeText(_path : String, _text : String)
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!sys.FileSystem.exists(_path))
        {
            throw new NotFoundException('${_path} not found');
        }

        sys.io.File.saveContent(_path, _text);
    }

    /**
     * //
     * @param _path //
     * @param _bytes //
     */
    public function writeBytes(_path : String, _bytes : Bytes)
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!sys.FileSystem.exists(_path))
        {
            throw new NotFoundException('${_path} not found');
        }

        sys.io.File.saveBytes(_path, _bytes);
    }

    /**
     * //
     * @param _path //
     * @param _text //
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
     * //
     * @param _path //
     * @param _bytes //
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
     * //
     * @param _path //
     * @return String
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
     * //
     * @param _path //
     * @return Bytes
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
}
