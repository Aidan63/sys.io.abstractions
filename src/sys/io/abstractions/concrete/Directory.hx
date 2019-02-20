package sys.io.abstractions.concrete;

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
        sys.FileSystem.createDirectory(_path);
    }

    /**
     * //
     * @param _path //
     */
    public function remove(_path : String)
    {
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
        return sys.FileSystem.readDirectory(_path);
    }

    /**
     * //
     * @param _path //
     * @return Array<String>
     */
    public function readDirectories(_path : String) : Array<String>
    {
        return [ for (item in sys.FileSystem.readDirectory(_path)) if (sys.FileSystem.isDirectory(item)) item ];
    }

    /**
     * //
     * @param _path //
     * @return Array<String>
     */
    public function readFiles(_path : String) : Array<String>
    {
        return [ for (item in sys.FileSystem.readDirectory(_path)) if (!sys.FileSystem.isDirectory(item)) item ];
    }

    /**
     * //
     * @param _path1 //
     * @param _path2 //
     */
    public function rename(_path1 : String, _path2 : String)
    {
        sys.FileSystem.rename(_path1, _path2);
    }
}
