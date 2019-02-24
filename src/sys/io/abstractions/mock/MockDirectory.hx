package sys.io.abstractions.mock;

import sys.io.abstractions.exceptions.ArgumentException;
import sys.io.abstractions.exceptions.NotFoundException;

using Lambda;
using StringTools;

/**
 * //
 */
class MockDirectory implements IDirectory
{
    final files : Map<String, MockFileData>;

    final directories : Array<String>;

    public function new(_files : Map<String, MockFileData>, _directories : Array<String>)
    {
        files = _files;
        directories = _directories;
    }

    /**
     * //
     * @param _path //
     * @return Bool
     */
    public function exist(_path : String) : Bool
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        var normalized = haxe.io.Path.normalize(_path);

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
     * Creates a new directory.
     * @param _path Directory path.
     */
    public function create(_path : String)
    {
        if (_path.trim().length == 0)
        {
            throw new ArgumentException('Provided path is only whitespace');
        }

        var normalized = haxe.io.Path.addTrailingSlash(haxe.io.Path.normalize(_path));

        directories.push(normalized);
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

        var normalized = haxe.io.Path.addTrailingSlash(haxe.io.Path.normalize(_path));

        var totalRemoved = 0;
        
        var toRemove = [];
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

        var toRemove = [];
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

        if (totalRemoved == 0)
        {
            throw new NotFoundException('Directory ${normalized} not found');
        }
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

        var output    = [];
        var normalized = haxe.io.Path.addTrailingSlash(haxe.io.Path.normalize(_path));

        if (!exist(normalized))
        {
            throw new NotFoundException('Directory ${normalized} does not exist');
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

        var normalized = haxe.io.Path.normalize(_path);

        if (!exist(normalized) && !files.exists(normalized))
        {
            throw new NotFoundException('${normalized} is not a file or directory');
        }

        return !files.exists(normalized);
    }
}
