name                ?=
icon                ?=
size                ?= false

ICONS_URL           := https://raw.githubusercontent.com/twbs/icons/main/icons
ICONS_PATH          := ./src/components/icons
COMPONENT_EXTENSION := astro
ASTRO_PROPS         := $(shell echo '---\nexport interface Props {\n  size: number;\n}\n\nconst { size } = Astro.props;\n---\n\n')
SVELTE_PROPS        := $(shell echo '<script lang="ts">\n\texport let size\: number;\n<\/script>\n\n')

ifeq ($(OS),Windows_NT) 
detected_OS := Windows
else
detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
endif
$(info "$(detected_OS)")

run:
	npm run dev

start:
	npm run start

install:
	bun install || npm install

build:
	(bun install && bun run build:debug) || (npm install -force && npm run build:debug)

release:
	bun run build || npm run build

debug:
	bun run build:debug || npm run build:debug

format:
	npm run format

clean:
	python3 clean.py || python clean.py

upgrade:
	bun x npm-check-updates -u || npx npm-check-updates -u

icon:
	@curl -s $(ICONS_URL)/$(icon).svg -o $(component_name).$(COMPONENT_EXTENSION)
ifeq ($(size), true)
ifeq ($(COMPONENT_EXTENSION), svelte)
	@sed -i "" -e '1s/^/$(SVELTE_PROPS)/' $(component_name).$(COMPONENT_EXTENSION)
else
	@sed -i "" -e '1s/^/$(ASTRO_PROPS)/' $(component_name).$(COMPONENT_EXTENSION)
endif
	@sed -i "" -e 's/width="16"/width={size}/g' $(component_name).$(COMPONENT_EXTENSION) \
	&& sed -i "" -e 's/height="16"/height={size}/g' $(component_name).$(COMPONENT_EXTENSION)
endif
	@echo '' >> $(component_name).$(COMPONENT_EXTENSION) \
	&& mv $(component_name).$(COMPONENT_EXTENSION) $(ICONS_PATH)
