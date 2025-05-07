CC = g++
CFLAGS = -g -Wall -fPIC -Iinclude
LDFLAGS = -Wno-undef -lcurl -lcrypto -lssl -lpam --shared

# Determine which folder to use
libdir.x86_64 = /lib64/security
libdir.i686   = /lib/security

MACHINE := $(shell uname -m)
libdir = $(libdir.$(MACHINE))

target = pam_privacyidea.so
objects = src/pam_privacyidea.o src/privacyidea.o

all: pam_privacyidea.so

$(objects): src/%.o: src/%.cpp

%.o:
	$(CC) -c $(CFLAGS) $< -o $@

$(target): $(objects)
	$(CC) -o $@ $^ $(LDFLAGS)

clean:
	rm -f src/*.o $(target)

install: all
	strip --strip-unneeded $(target)
	mkdir -p $(libdir)
	cp $(target) $(libdir)/$(target)

uninstall:
	rm $(libdir)/$(target)

.PHONY: all clean install uninstall
