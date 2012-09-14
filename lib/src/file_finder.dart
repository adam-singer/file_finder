class FileFinder {
  static Future<List<String>> find(String path, List<String> filemasks,
      [bool searchForFiles = true, bool searchForDirs = false,
      bool recursive = false, bool ignoreCase]) {

    var dir = new Directory(new Path(path).toNativePath());
    var lister = new FilteredDirectoryLister(dir, filemasks, recursive,
        ignoreCase);

    var results = [];
    if(searchForFiles) {
      lister.onFile = (file) => results.add(file);
    }

    if(searchForDirs) {
      lister.onDir = (dir) => results.add(dir);
    }

    var completer = new Completer<List<String>>();
    lister.onDone = (_) => completer.complete(results);

    return completer.future;
  }
}
