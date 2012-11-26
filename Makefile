VERSION = 0.0.1

MAINFILE = "maze.pl"

all:
  echo It works!

install:
  cp bin/$(MAINFILE) /usr/bin/$(MAINFILE)
  chmod 775 /usr/bin/$(MAINFILE)

clean:
  rm -f $(MAINFILE)