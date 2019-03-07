package sys.io.abstractions;

/**
 * Interface for modifying files and directories.
 */
interface IFileSystem
{
    /**
     * Access to file system directories.
     */
    final directory : IDirectory;

    /**
     * Access to file on the file system.
     */
    final file : IFile;
}
