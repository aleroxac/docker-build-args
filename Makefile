.PHONY: install
install:
	@[ ! -e /usr/bin/virtualenv ] && python -m pip install --break-system-packages virtualenv || true
	@[ ! -e ~/.virtualenvs ] && mkdir -v ~/.virtualenvs || true
	@[ ! -e ~/.virtualenvs/docker-build-args ] && python -m virtualenv ~/.virtualenvs/docker-build-args || true
	@~/.virtualenvs/docker-build-args/pip install -r docker-build-args/requirements.txt
	@[ ! -e /usr/local/bin/docker-build-args ] && sudo cp -v main.py /usr/local/bin/docker-build-args || true
	@echo "Great! Now, you can run: docker-build-args --help"

.PHONY: uninstall
uninstall:
	@[ -e ~/.virtualenvs/docker-build-args ] && rm -rfv ~/.virtualenvs/docker-build-args || true
	@[ -e /usr/local/bin/docker-build-args ] && rm -fv /usr/local/bin/docker-build-args || true

.PHONY: activate
activate:
	@source .venv/bin/activate
