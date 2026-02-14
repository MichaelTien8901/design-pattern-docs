all: csharp cpp delphi

csharp:
	docker compose run --rm --build csharp

cpp:
	docker compose run --rm --build cpp

delphi:
	docker compose run --rm --build delphi

clean:
	docker compose down --rmi local
	rm -rf cpp/build delphi/*.o delphi/*.ppu

.PHONY: all csharp cpp delphi clean
