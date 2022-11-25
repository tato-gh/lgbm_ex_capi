.phony: all clean

PRIV = $(MIX_APP_PATH)/priv
OBJ = $(MIX_APP_PATH)/obj

NIF = $(PRIV)/lgbm_ex_capi.so
C_SRC = $(wildcard c_src/*.cpp)
C_OBJS = $(C_SRC:c_src/%.cpp=$(OBJ)/%.o)

CFLAGS = -std=c++17 -fpic -fpermissive
LDFLAGS = -lpthread -dynamiclib -undefined -shared

ERL_CFLAGS = -I$(ERL_EI_INCLUDE_DIR)
ERL_LDFLAGS = -L$(ERL_EI_LIBDIR) -lei

LIGHTGBM_CFLAGS = -I$(LIGHTGBM_DIR)/include
LIGHTGBM_LDFLAGS = -Wl,-rpath,$(LIGHTGBM_DIR)

all: $(PRIV) $(OBJ) $(NIF)

$(PRIV):
	mkdir -p $(PRIV)

$(OBJ):
	mkdir -p $(OBJ)

$(NIF): $(C_OBJS)
	$(CC) $(LDFLAGS) $(ERL_LDFLAGS) $(LIGHTGBM_LDFLAGS) -o $@ $^ $(LIGHTGBM_DIR)/lib_lightgbm.so

$(C_OBJS): $(OBJ)/%.o: c_src/%.cpp
	$(CC) -c $(CFLAGS) $(ERL_CFLAGS) $(LIGHTGBM_CFLAGS) -o $@ $<

clean:
	$(RM) $(NIF) $(C_OBJS)
