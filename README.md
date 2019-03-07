# sys.io.abstractions

[![Build Status](https://dev.azure.com/flurry-engine/sys.io.abstractions/_apis/build/status/Aidan63.sys.io.abstractions?branchName=master)](https://dev.azure.com/flurry-engine/sys.io.abstractions/_build/latest?definitionId=2&branchName=master)

Testable IO access for haxe!

Provides an api similar to `sys.io.File` and `sys.FileSystem` but abstracted to allow easy testing. The library only supports haxe 4, throws typed exceptions, and is null safe!

For the most part the api acts the same as haxe's file system access, the following is a small example of creating testable file system access. 

```haxe
class Component
{
    final fileSystem : IFileSystem;

    public function new(_fileSystem : Null<IFileSystem> = null)
    {
        fileSystem = _fileSystem == null ? new FileSystem() : _fileSystem;
    }

    public function work()
    {
        for (item in fileSystem.directory.read())
        {
            if (fileSystem.directory.isDirectory(item))
            {
                continue;
            }

            fileSystem.file.appendText(item, 'more text!');
        }
    }
}
```

With the constructor we can inject a mock file to allow testing our class.

```haxe
class Test
{
    public static function test()
    {
        var files = [
            '/home/aidan/documents/my_file1.txt' => MockFileData.fromText('hello '),
            '/home/aidan/documents/my_file1.txt' => MockFileData.fromText('world ')
        ];
        var worker = new Component(new MockFileSystem(files));
        worker.work();

        trace(files.get('/home/aidan/documents/my_file1.txt').text); // 'hello more text!'
        trace(files.get('/home/aidan/documents/my_file2.txt').text); // 'world more text!'
    }
}
```
