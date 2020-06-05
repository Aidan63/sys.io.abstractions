package sys.io.abstractions.mock;

import sys.io.abstractions.exceptions.ArgumentException;
import sys.io.abstractions.exceptions.NotFoundException;

using Lambda;
using StringTools;

/**
 * Mock directory class for easy testing.
 */
class MockDirectory implements IDirectory
{
    /**
     * All files and their path in the mock file system.
     */
    final files : Map<String, MockFileData>;

    /**
     * Exising directories which may not have files in them.
     */
    final directories : Array<String>;

    public function new(_files : Map<String, MockFileData>, _directories : Array<String>)
    {
        files = _files;
        directories = _directories;
    }

    /**
     * Checks if a directory exists.
     * @param _path Directory to check.
     * @return Bool
     */
    public function exist(_path : String) : Bool
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        final normalized = haxe.io.Path.normalize(_path);

        for (directory in directories)
        {
            if (directory.startsWith(normalized))
            {
                return true;
            }
        }

        for (path in files.keys())
        {
            if (path.startsWith(normalized))
            {
                return true;
            }
        }

        return false;
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

        final normalized = haxe.io.Path.addTrailingSlash(haxe.io.Path.normalize(_path));

        directories.push(normalized);
    }

    /**
     * Recursively remove a directory from the file system.
     * @param _path Directory to remove.
     * @throws ArgumentException If the provided path if whitespace.
     */
    public function remove(_path : String)
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        final normalized = haxe.io.Path.addTrailingSlash(haxe.io.Path.normalize(_path));

        var totalRemoved = 0;
        
        final toRemove = [];
        for (directory in directories)
        {
            if (directory.startsWith(normalized))
            {
                toRemove.push(directory);
            }
        }

        for (path in toRemove)
        {
            directories.remove(path);
            totalRemoved++;
        }

        final toRemove = [];
        for (path in files.keys())
        {
            if (path.startsWith(normalized))
            {
                toRemove.push(path);
            }
        }

        for (path in toRemove)
        {
            files.remove(path);
            totalRemoved++;
        }
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

        final output    = [];
        final normalized = haxe.io.Path.addTrailingSlash(haxe.io.Path.normalize(_path));

        if (!exist(normalized))
        {
            throw new NotFoundException('Directory $normalized does not exist');
        }

        for (directory in directories)
        {
            if (directory.startsWith(normalized))
            {
                var item = haxe.io.Path.join([ normalized, directory.substr(normalized.length).split('/')[0] ]);
                if (!output.has(item))
                {
                    output.push(item);
                }
            }
        }

        for (path in files.keys())
        {
            if (path.startsWith(normalized))
            {
                var item = haxe.io.Path.join([ normalized, path.substr(normalized.length).split('/')[0] ]);
                if (!output.has(item))
                {
                    output.push(item);
                }
            }
        }

        return output;
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

        final normalized = haxe.io.Path.normalize(_path);

        if (!exist(normalized) && !files.exists(normalized))
        {
            throw new NotFoundException('$normalized is not a file or directory');
        }

        return !files.exists(normalized);
    }
}
