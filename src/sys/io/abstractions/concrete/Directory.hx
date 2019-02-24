package sys.io.abstractions.concrete;

import sys.io.abstractions.exceptions.ArgumentException;
import sys.io.abstractions.exceptions.NotFoundException;

using StringTools;

/**
 * Concrete directory implementation, operates on the actual file system.
 */
class Directory implements IDirectory
{
    public function new()
    {
        //
    }

    /**
     * Creates a new directory.
     * @param _path Directory path.
     */
    public function create(_path : String)
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        sys.FileSystem.createDirectory(_path);
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

        sys.FileSystem.deleteDirectory(_path);
    }

    /**
     * //
     * @param _path //
     * @return Bool
     */
    public function exist(_path : String) : Bool
    {
        return sys.FileSystem.exists(_path) && sys.FileSystem.isDirectory(_path);
    }

    /**
     * //
     * @param _path //
     * @return Array<String>
     */
    public function read(_path : String) : Array<String>
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!sys.FileSystem.exists(_path))
        {
            throw new NotFoundException('${_path} not found');
        }

        return sys.FileSystem.readDirectory(_path);
    }

    /**
     * //
     * @param _path //
     * @return Bool
     */
    public function isDirectory(_path : String) : Bool
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        if (!sys.FileSystem.exists(_path))
        {
            throw new NotFoundException('${_path} not found');
        }

        return sys.FileSystem.isDirectory(_path);
    }
}
