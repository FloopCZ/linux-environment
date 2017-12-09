flags = [
  '-Wall',
  '-pedantic'
  '-Werror',
  '-DNDEBUG',
  '-x',
  'c++',
  '-std=c++17',
]

def FlagsForFile(filename, **kwargs):
  return { 'flags': flags }
