package sys.io.abstractions.mock;

import haxe.io.Bytes;
import buddy.BuddySuite;
import sys.io.abstractions.exceptions.ArgumentException;
import sys.io.abstractions.exceptions.NotFoundException;

using buddy.Should;
using Safety;

class TestMockFile extends BuddySuite
{
    public function new()
    {
        describe('TestMockFile', {
            describe('creating a file', {
                final f : Map<String, MockFileData> = [];
                final d : Array<String> = [];
                final file = new MockFile(f, d);

                it('can create a new empty file', {
                    file.create('/home/user/documents/file1.txt');
                    f.exists('/home/user/documents/file1.txt').should.be(true);

                    final file = f.get('/home/user/documents/file1.txt');
                    if (file != null)
                    {
                        file.data.length.should.be(0);
                    }
                });

                it('will normalize the path and create a new empty file', {
                    file.create('/home/user/documents/folder/../file2.txt');
                    f.exists('/home/user/documents/file2.txt').should.be(true);

                    final file = f.get('/home/user/documents/file1.txt');
                    if (file != null)
                    {
                        file.data.length.should.be(0);
                    }
                });

                it('will throw an argument exception when passed whitespace for the path', {
                    file.create.bind('').should.throwType(ArgumentException);
                    file.create.bind(' ').should.throwType(ArgumentException);
                    file.create.bind('   ').should.throwType(ArgumentException);
                });
            });

            describe('removing a file', {
                final f = [
                    '/home/user/documents/file1.txt' => MockFileData.fromBytes(),
                    '/home/user/documents/file2.txt' => MockFileData.fromBytes()
                ];
                final d = [];
                final file = new MockFile(f, d);

                it('can remove an existing file', {
                    file.remove('/home/user/documents/file1.txt');
                    f.exists('/home/user/documents/file1.txt').should.be(false);
                });

                it('will normalize the path and remove the file', {
                    file.remove('/home/user/documents/folder/../file2.txt');
                    f.exists('/home/user/documents/folder/../file2.txt').should.be(false);
                });

                it('will throw an argument exception when passed whitespace for the path', {
                    file.remove.bind('').should.throwType(ArgumentException);
                    file.remove.bind(' ').should.throwType(ArgumentException);
                    file.remove.bind('   ').should.throwType(ArgumentException);
                });

                it('will will perform no operation if the file does not exist', {
                    file.remove('/home/user/does_not_exist.txt');
                });
            });

            describe('checking if a file exists', {
                final f = [
                    '/home/user/documents/file1.txt' => MockFileData.fromText('file 1'),
                    '/home/user/documents/file2.txt' => MockFileData.fromText('file 2')
                ];
                final d = [];
                final file = new MockFile(f, d);

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

            describe('stream writing to a file', {
                final f = [ '/home/user/documents/file1.txt' => MockFileData.fromText('data ') ];
                final file = new MockFile(f, []);

                it('allows stream writing to the file', {
                    final output = file.write('/home/user/documents/file1.txt');
                    output.writeString('hello ');
                    output.writeString('world!');
                    output.close();

                    f.get('/home/user/documents/file1.txt').text.should.be('data hello world!');
                });

                it('will throw an argument exception when passed whitespace for the path', {
                    file.write.bind('').should.throwType(ArgumentException);
                    file.write.bind(' ').should.throwType(ArgumentException);
                    file.write.bind('   ').should.throwType(ArgumentException);
                });

                it('will thrown a not found exception if the file was not found', {
                    file.write.bind('/home/user/does_not_exist.txt').should.throwType(NotFoundException);
                });
            });

            describe('stream reading from a file', {
                final f = [ '/home/user/documents/file1.txt' => MockFileData.fromText('data hello world!') ];
                final file = new MockFile(f, []);

                it('allows stream reading from the file', {
                    final input = file.read('/home/user/documents/file1.txt');
                    input.readString(5).should.be('data ');
                    input.readString(6).should.be('hello ');
                    input.readString(6).should.be('world!');
                });

                it('will throw an argument exception when passed whitespace for the path', {
                    file.write.bind('').should.throwType(ArgumentException);
                    file.write.bind(' ').should.throwType(ArgumentException);
                    file.write.bind('   ').should.throwType(ArgumentException);
                });

                it('will thrown a not found exception if the file was not found', {
                    file.write.bind('/home/user/does_not_exist.txt').should.throwType(NotFoundException);
                });
            });

            describe('writing text to a file', {
                final f = [
                    '/home/user/documents/file1.txt' => MockFileData.fromText('file 1'),
                    '/home/user/documents/file2.txt' => MockFileData.fromText('file 2')
                ];
                final d = [];
                final file = new MockFile(f, d);

                it('can set the file contents to a string', {
                    file.writeText('/home/user/documents/file1.txt', 'hello');
                    file.writeText('/home/user/documents/folder/../file2.txt', 'world');

                    final file1 = f.get('/home/user/documents/file1.txt');
                    if (file1 != null)
                    {
                        file1.data.length.should.be(5);
                        file1.text.should.be('hello');
                    }
                    final file2 = f.get('/home/user/documents/file2.txt');
                    if (file2 != null)
                    {
                        file2.data.length.should.be(5);
                        file2.text.should.be('world');
                    }
                });

                it('will throw an argument exception when passed whitespace for the path', {
                    file.writeText.bind('', '').should.throwType(ArgumentException);
                    file.writeText.bind(' ', '').should.throwType(ArgumentException);
                    file.writeText.bind('   ', '').should.throwType(ArgumentException);
                });

                it('will thrown a not found exception if the file was not found', {
                    file.writeText('/home/user/does_not_exist.txt', '');
                    f.get('/home/user/does_not_exist.txt').sure();
                });
            });

            describe('writing bytes to a file', {
                final f = [
                    '/home/user/documents/file1.txt' => MockFileData.fromText('file 1'),
                    '/home/user/documents/file2.txt' => MockFileData.fromText('file 2')
                ];
                final d = [];
                final file = new MockFile(f, d);

                it('can set the file contents to a bytes', {
                    file.writeBytes('/home/user/documents/file1.txt', Bytes.alloc(10));
                    file.writeBytes('/home/user/documents/folder/../file2.txt', Bytes.alloc(12));

                    final file1 = f.get('/home/user/documents/file1.txt');
                    if (file1 != null)
                    {
                        file1.data.length.should.be(10);
                    }
                    final file2 = f.get('/home/user/documents/file2.txt');
                    if (file2 != null)
                    {
                        file2.data.length.should.be(12);
                    }
                });

                it('will throw an argument exception when passed whitespace for the path', {
                    file.writeBytes.bind('', Bytes.alloc(0)).should.throwType(ArgumentException);
                    file.writeBytes.bind(' ', Bytes.alloc(0)).should.throwType(ArgumentException);
                    file.writeBytes.bind('   ', Bytes.alloc(0)).should.throwType(ArgumentException);
                });

                it('will create the file if it does not already exist', {
                    file.writeBytes('/home/user/does_not_exist.txt', Bytes.alloc(0));
                    f.get('/home/user/does_not_exist.txt').sure();
                });
            });

            describe('appending text to a file', {
                final f = [ '/home/user/documents/file1.txt' => MockFileData.fromText('hello') ];
                final d = [];
                final file = new MockFile(f, d);

                it('can append a string to a files data', {
                    file.appendText('/home/user/documents/file1.txt', 'world');

                    final file = f.get('/home/user/documents/file1.txt');
                    if (file != null)
                    {
                        file.text.should.be('helloworld');
                    }
                });

                it('will throw an argument exception when passed whitespace for the path', {
                    file.appendText.bind('', '').should.throwType(ArgumentException);
                    file.appendText.bind(' ', '').should.throwType(ArgumentException);
                    file.appendText.bind('   ', '').should.throwType(ArgumentException);
                });

                it('will thrown a not found exception if the file was not found', {
                    file.appendText.bind('/home/user/does_not_exist.txt', '').should.throwType(NotFoundException);
                });
            });

            describe('appending bytes to a file', {
                final f = [ '/home/user/documents/file1.txt' => MockFileData.fromText('hello') ];
                final d = [];
                final file = new MockFile(f, d);

                it('can append a string to a files data', {
                    file.appendBytes('/home/user/documents/file1.txt', Bytes.ofString('world'));

                    final file = f.get('/home/user/documents/file1.txt');
                    if (file != null)
                    {
                        file.text.should.be('helloworld');
                    }
                });

                it('will throw an argument exception when passed whitespace for the path', {
                    file.appendBytes.bind('', Bytes.alloc(0)).should.throwType(ArgumentException);
                    file.appendBytes.bind(' ', Bytes.alloc(0)).should.throwType(ArgumentException);
                    file.appendBytes.bind('   ', Bytes.alloc(0)).should.throwType(ArgumentException);
                });

                it('will thrown a not found exception if the file was not found', {
                    file.appendBytes.bind('/home/user/does_not_exist.txt', Bytes.alloc(0)).should.throwType(NotFoundException);
                });
            });

            describe('getting bytes from a file', {
                final f = [ '/home/user/documents/file1.txt' => MockFileData.fromText('hello') ];
                final d = [];
                final file = new MockFile(f, d);

                it('can read the bytes from a file', {
                    file.getBytes('/home/user/documents/file1.txt').toString().should.be('hello');
                });

                it('will throw an argument exception when passed whitespace for the path', {
                    file.getBytes.bind('').should.throwType(ArgumentException);
                    file.getBytes.bind(' ').should.throwType(ArgumentException);
                    file.getBytes.bind('   ').should.throwType(ArgumentException);
                });

                it('will thrown a not found exception if the file was not found', {
                    file.getBytes.bind('/home/user/does_not_exist.txt').should.throwType(NotFoundException);
                });
            });

            describe('getting text from a file', {
                final f = [ '/home/user/documents/file1.txt' => MockFileData.fromText('hello') ];
                final d = [];
                final file = new MockFile(f, d);

                it('can read the text from a file', {
                    file.getText('/home/user/documents/file1.txt').should.be('hello');
                });

                it('will throw an argument exception when passed whitespace for the path', {
                    file.getText.bind('').should.throwType(ArgumentException);
                    file.getText.bind(' ').should.throwType(ArgumentException);
                    file.getText.bind('   ').should.throwType(ArgumentException);
                });

                it('will thrown a not found exception if the file was not found', {
                    file.getText.bind('/home/user/does_not_exist.txt').should.throwType(NotFoundException);
                });
            });

            describe('moving a file', {
                final f = [ '/home/user/documents/file1.txt' => MockFileData.fromText('hello') ];
                final d = [];
                final file = new MockFile(f, d);

                it('can move a file to another location', {
                    file.move('/home/user/documents/file1.txt', '/home/user/moved.txt');
                    file.getText('/home/user/moved.txt').should.be('hello');
                    file.exists('/home/user/documents/file1.txt').should.be(false);
                });

                it('will throw an argument exception when passed whitespace for the source or destination path', {
                    file.move.bind('', 'dst.txt').should.throwType(ArgumentException);
                    file.move.bind(' ', 'dst.txt').should.throwType(ArgumentException);
                    file.move.bind('   ', 'dst.txt').should.throwType(ArgumentException);

                    file.move.bind('src.txt', '').should.throwType(ArgumentException);
                    file.move.bind('src.txt', ' ').should.throwType(ArgumentException);
                    file.move.bind('src.txt', '   ').should.throwType(ArgumentException);
                });

                it('will thrown a not found exception if the source file was not found', {
                    file.move.bind('/home/user/does_not_exist.txt', 'dst.txt').should.throwType(NotFoundException);
                });
            });

            describe('copying a file', {
                final f = [ '/home/user/documents/file1.txt' => MockFileData.fromText('hello') ];
                final d = [];
                final file = new MockFile(f, d);

                it('can move a file to another location', {
                    file.copy('/home/user/documents/file1.txt', '/home/user/moved.txt');
                    file.getText('/home/user/moved.txt').should.be('hello');
                    file.getText('/home/user/documents/file1.txt').should.be('hello');
                });

                it('will throw an argument exception when passed whitespace for the source or destination path', {
                    file.copy.bind('', 'dst.txt').should.throwType(ArgumentException);
                    file.copy.bind(' ', 'dst.txt').should.throwType(ArgumentException);
                    file.copy.bind('   ', 'dst.txt').should.throwType(ArgumentException);

                    file.copy.bind('src.txt', '').should.throwType(ArgumentException);
                    file.copy.bind('src.txt', ' ').should.throwType(ArgumentException);
                    file.copy.bind('src.txt', '   ').should.throwType(ArgumentException);
                });

                it('will thrown a not found exception if the source file was not found', {
                    file.copy.bind('/home/user/does_not_exist.txt', 'dst.txt').should.throwType(NotFoundException);
                });
            });
        });
    }
}
