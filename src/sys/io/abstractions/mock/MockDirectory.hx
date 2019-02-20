package sys.io.abstractions.mock;

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
        directories.push(haxe.io.Path.addTrailingSlash(haxe.io.Path.normalize(_path)));
    }

    /**
     * //
     * @param _path //
     */
    public function remove(_path : String)
    {
        var normalized = haxe.io.Path.addTrailingSlash(haxe.io.Path.normalize(_path));
        
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
        }
    }

    /**
     * //
     * @param _path //
     * @return Array<String>
     */
    public function read(_path : String) : Array<String>
    {      
        var output    = [];
        var normalized = haxe.io.Path.addTrailingSlash(haxe.io.Path.normalize(_path));

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
        return !files.exists(haxe.io.Path.normalize(_path));
    }
}
