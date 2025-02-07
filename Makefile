CC = gcc
CFLAGS = -Wall
BUILD_DIR = out
DEST_DIR = deb

all: $(BUILD_DIR)/helloworld

$(BUILD_DIR)/helloworld: src/helloworld.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $@ $^

install:
	install -D -m 0755 $(BUILD_DIR)/helloworld $(DESTDIR)/usr/bin/helloworld

package: clean all
	@mkdir -p $(DEST_DIR)
	fakeroot debian/rules binary
	mv ../helloworld* $(DEST_DIR)/

clean:
	rm -rf $(BUILD_DIR) $(DEST_DIR)
