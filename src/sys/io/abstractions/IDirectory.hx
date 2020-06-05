package sys.io.abstractions;

/**
 * Interface for directory operations
 * Provides functions for creating, removing, checking, and reading directories.
 */
interface IDirectory
{
    /**
     * Creates the directory if it does not exist.
     * @param _path Directory to create.
     * @throws ArgumentException If the provided path if whitespace.
     */
    function create(_path : String) : Void;

    /**
     * Recursively remove a directory from the file system.
     * @param _path Directory to remove.
     * @throws ArgumentException If the provided path if whitespace.
     */
    function remove(_path : String) : Void;

    /**
     * Checks if a directory exists.
     * @param _path Directory to check.
     * @return Bool
     */
    function exist(_path : String) : Bool;

    /**
     * Gets all files and directories in a directory.
     * @param _path Directory to read.
     * @return Array<String>
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the directory does not exist.
     */
    function read(_path : String) : Array<String>;

    /**
     * Checks if the provided path is a directory
     * @param _path Path to check.
     * @return Bool
     * @throws ArgumentException If the provided path if whitespace.
     * @throws NotFoundException If the directory does not exist.
     */
    function isDirectory(_path : String) : Bool;
}
