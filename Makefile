# you can override on command line
lang = en

define run-in-docker =
	docker run -it --rm -v $$(pwd):/home/makedoc/linbit-documentation linbit-documentation /bin/sh -c 'cd ~/linbit-documentation && make $(patsubst %-docker,%,$@) lang=$(lang)'
endef

.PHONY: README.html-docker
README.html: README.adoc
	asciidoctor -n -o $@ $<

README.html-docker: dockerimage
	$(run-in-docker)

Dockerfile:
	@{ echo "FROM ubuntu:xenial" ;\
	echo "MAINTAINER Roland Kammerer <roland.kammerer@linbit.com>" ;\
	echo "RUN groupadd --gid $$(id -g) makedoc" ;\
	echo "RUN useradd -u $$(id -u) -g $$(id -g) makedoc" ;\
	echo "RUN apt-get update -y && apt-get install -y make inkscape ruby" ;\
	echo "RUN gem install --pre asciidoctor-pdf" ;\
	echo "RUN gem install --pre asciidoctor-pdf-cjk" ;\
	echo "USER makedoc" ;} > $@

.PHONY: dockerimage
dockerimage: Dockerfile
	if ! docker images --format={{.Repository}}:{{.Tag}} | grep -q 'linbit-documentation:latest'; then \
		docker build -t linbit-documentation . ; \
	fi

# UG 9
.PHONY: UG9-pdf-finalize UG9-pdf-finalize-docker UG9-html-finalize UG9-html-finalize-docker
UG9-pdf-finalize:
	make -C UG9 pdf-finalize lang=$(lang)

UG9-pdf-finalize-docker: dockerimage
	$(run-in-docker)

UG9-html-finalize:
	make -C UG9 html-finalize lang=$(lang)

UG9-html-finalize-docker: dockerimage
	$(run-in-docker)

# UG 8.4
.PHONY: UG8.4-pdf-finalize UG8.4-pdf-finalize-docker UG8.4-html-finalize UG8.4-html-finalize-docker
UG8.4-pdf-finalize:
	make -C UG8.4 pdf-finalize lang=$(lang)

UG8.4-pdf-finalize-docker: dockerimage
	$(run-in-docker)

UG8.4-html-finalize:
	make -C UG8.4 html-finalize lang=$(lang)

UG8.4-html-finalize-docker: dockerimage
	$(run-in-docker)

## targets you can only use if you cloned the according *private* project
# tech guides
.PHONY: tech-guides-pdf-finalize tech-guides-pdf-finalize-docker
tech-guides-pdf-finalize:
	make -C tech-guides pdf-finalize

tech-guides-pdf-finalize-docker: dockerimage
	$(run-in-docker)
