package sys.io.abstractions.mock;

import haxe.io.Bytes;
import buddy.BuddySuite;

using buddy.Should;

class TestMockFile extends BuddySuite
{
    public function new()
    {
        describe('TestMockFile', {
            describe('creating a file', {
                var f : Map<String, MockFileData> = [];
                var d : Array<String> = [];
                var file = new MockFile(f, d);

                it('can create a new empty file', {
                    file.create('/home/user/documents/file1.txt');
                    f.exists('/home/user/documents/file1.txt').should.be(true);
                    var file = f.get('/home/user/documents/file1.txt');
                    if (file != null)
                    {
                        file.data.length.should.be(0);
                    }
                });

                it('will normalize the path and create a new empty file', {
                    file.create('/home/user/documents/folder/../file2.txt');
                    f.exists('/home/user/documents/file2.txt').should.be(true);
                    var file = f.get('/home/user/documents/file1.txt');
                    if (file != null)
                    {
                        file.data.length.should.be(0);
                    }
                });
            });

            describe('removing a file', {
                var f = [
                    '/home/user/documents/file1.txt' => MockFileData.fromBytes(),
                    '/home/user/documents/file2.txt' => MockFileData.fromBytes()
                ];
                var d = [];
                var file = new MockFile(f, d);

                it('can remove an existing file', {
                    file.remove('/home/user/documents/file1.txt');
                    f.exists('/home/user/documents/file1.txt').should.be(false);
                });

                it('will normalize the path and remove the file', {
                    file.remove('/home/user/documents/folder/../file.txt');
                    f.exists('/home/user/documents/folder/../file2.txt').should.be(false);
                });
            });

            describe('checking if a file exists', {
                var f = [
                    '/home/user/documents/file1.txt' => MockFileData.fromText('file 1'),
                    '/home/user/documents/file2.txt' => MockFileData.fromText('file 2')
                ];
                var d = [];
                var file = new MockFile(f, d);

                it('will return true if the file is found', {
                    file.exists('/home/user/documents/file1.txt').should.be(true);
                    file.exists('/home/user/documents/file2.txt').should.be(true);
                });

                it('will return false if the file is not found', {
                    file.exists('/home/user/documents/file3.txt').should.be(false);
                });

                it('will correctly normalize input paths', {
                    file.exists('/home/user/documents/folder/../file1.txt').should.be(true);
                });
            });

            describe('writing text to a file', {
                var f = [
                    '/home/user/documents/file1.txt' => MockFileData.fromText('file 1'),
                    '/home/user/documents/file2.txt' => MockFileData.fromText('file 2')
                ];
                var d = [];
                var file = new MockFile(f, d);

                it('can set the file contents to a string', {
                    file.writeText('/home/user/documents/file1.txt', 'hello');
                    file.writeText('/home/user/documents/folder/../file2.txt', 'world');

                    var file1 = f.get('/home/user/documents/file1.txt');
                    if (file1 != null)
                    {
                        file1.data.length.should.be(5);
                        file1.text.should.be('hello');
                    }
                    var file2 = f.get('/home/user/documents/file2.txt');
                    if (file2 != null)
                    {
                        file2.data.length.should.be(5);
                        file2.text.should.be('world');
                    }
                });
            });

            describe('writing bytes to a file', {
                var f = [
                    '/home/user/documents/file1.txt' => MockFileData.fromText('file 1'),
                    '/home/user/documents/file2.txt' => MockFileData.fromText('file 2')
                ];
                var d = [];
                var file = new MockFile(f, d);

                it('can set the file contents to a bytes', {
                    file.writeBytes('/home/user/documents/file1.txt', Bytes.alloc(10));
                    file.writeBytes('/home/user/documents/folder/../file2.txt', Bytes.alloc(12));

                    var file1 = f.get('/home/user/documents/file1.txt');
                    if (file1 != null)
                    {
                        file1.data.length.should.be(10);
                    }
                    var file2 = f.get('/home/user/documents/file2.txt');
                    if (file2 != null)
                    {
                        file2.data.length.should.be(12);
                    }
                });
            });

            describe('appending text to a file', {
                var f = [ '/home/user/documents/file1.txt' => MockFileData.fromText('hello') ];
                var d = [];
                var file = new MockFile(f, d);

                it('can append a string to a files data', {
                    file.appendText('/home/user/documents/file1.txt', 'world');

                    var file = f.get('/home/user/documents/file1.txt');
                    if (file != null)
                    {
                        file.text.should.be('helloworld');
                    }
                });
            });

            describe('appending bytes to a file', {
                var f = [ '/home/user/documents/file1.txt' => MockFileData.fromText('hello') ];
                var d = [];
                var file = new MockFile(f, d);

                it('can append a string to a files data', {
                    file.appendBytes('/home/user/documents/file1.txt', Bytes.ofString('world'));

                    var file = f.get('/home/user/documents/file1.txt');
                    if (file != null)
                    {
                        file.text.should.be('helloworld');
                    }
                });
            });

            describe('getting bytes from a file', {
                var f = [ '/home/user/documents/file1.txt' => MockFileData.fromText('hello') ];
                var d = [];
                var file = new MockFile(f, d);

                it('can read the bytes from a file', {
                    file.getBytes('/home/user/documents/file1.txt').toString().should.be('hello');
                });
            });

            describe('getting text from a file', {
                var f = [ '/home/user/documents/file1.txt' => MockFileData.fromText('hello') ];
                var d = [];
                var file = new MockFile(f, d);

                it('can read the text from a file', {
                    file.getText('/home/user/documents/file1.txt').should.be('hello');
                });
            });
        });
    }
}
