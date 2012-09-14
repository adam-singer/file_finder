#import('dart:io');
#import('../file_finder.dart');

main() {
  if(Platform.operatingSystem == 'windows') {
    findOnWindows();
    hookFindOnWindows();
  } else {
    // findOnUnix();
    // hookFindOnWindows;
  }
}

void findOnWindows() {
  var homePath = Platform.environment['HOMEPATH'];
  var path = new Path(homePath).toNativePath();
  var filemasks = ['.*', '?????', 'ntuser.*'];
  FileFinder.find(path, filemasks, searchForDirs: true, recursive: false)
  .then((files) {
    displayResults('Finder', filemasks, files);
  });
}

void hookFindOnWindows() {
  var windir = Platform.environment['windir'];
  var path = new Path(windir).append('system32').toNativePath();
  var filemasks = ['a*.exe', '????2.?ls'];
  var dir = new Directory(path);
  var lister = new FilteredDirectoryLister(dir, filemasks, recursive: false);
  var files = [];

  lister.onFile = (String file) {
    files.add(file);
  };

  lister.onDone = (_) {
    displayResults('Lister', filemasks, files);
  };
}

void displayResults(String finder, List filemasks, List results) {
  print('$finder: search done.');
  if(results.length == 0) {
    print('Nothing found for $filemasks.');
  } else {
    print('Search results for $filemasks.');
    for(var result in results) {
      print(result);
    }
  }

  print('-------------------');
}