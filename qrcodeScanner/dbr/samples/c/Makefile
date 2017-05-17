CC=gcc
CCFLAGS=-c
DBRLIB_PATH=../../lib
LDFLAGS=-L $(DBRLIB_PATH) -Wl,-rpath=$(DBRLIB_PATH) -Wl,-rpath=./

DBRLIB=-lDynamsoftBarcodeReader

TARGET=BarcodeReaderDemo
OBJECT=BarcodeReaderDemo.o
SOURCE=BarcodeReaderDemo.c

# build rule for target.
$(TARGET): $(OBJECT)
	$(CC) -o $(TARGET) $(OBJECT) $(DBRLIB) $(LDFLAGS)

# target to build an object file
$(OBJECT): $(SOURCE)
	$(CC) $(CCFLAGS) $(SOURCE)

# the clean target
.PHONY : clean
clean:
	rm -f $(OBJECT) $(TARGET)
