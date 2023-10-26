# Find all .fnl files in the repository
FENNEL_FILES := $(shell find . -type f -name '*.fnl')

# Convert .fnl files to corresponding .lua files
LUA_FILES := $(patsubst %.fnl,%.lua,$(FENNEL_FILES))

# Define the "all" target to compile all .fnl files
all: $(LUA_FILES)

# Compile Fennel to Lua
%.lua: %.fnl
	fennel --compile $< > $@

# Define the "clean" target
clean:
	rm -f $(LUA_FILES)

.PHONY: all clean

