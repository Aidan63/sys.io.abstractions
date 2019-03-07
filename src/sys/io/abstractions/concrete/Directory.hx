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
     * Creates the directory if it does not exist.
     * @param _path Directory to create.
     * @throws ArgumentException If the provided path if whitespace.
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
     * Recursively remove a directory from the file system.
     * @param _path Directory to remove.
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the directory does not exist.
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
     * Checks if a directory exists.
     * @param _path Directory to check.
     * @return Bool
     */
    public function exist(_path : String) : Bool
    {
        return sys.FileSystem.exists(_path) && sys.FileSystem.isDirectory(_path);
    }

    /**
     * Gets all files and directories in a directory.
     * @param _path Directory to read.
     * @return Array<String>
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the directory does not exist.
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
     * Checks if the provided path is a directory
     * @param _path Path to check.
     * @return Bool
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the directory does not exist.
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
