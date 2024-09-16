SHELL=/bin/bash
CONTAINERFILE=Containerfile
IMAGE_TAG = uidexample
POSITRON_UID_BASE=1001970000

all: Containerfile

$(CONTAINERFILE): buildconfig.yaml
	yq -r .spec.source.dockerfile $< > $@ || { rm -f $@; exit 1; }

.image-build: $(CONTAINERFILE)
	podman build -t $(IMAGE_TAG) -f $(CONTAINERFILE) \
		--build-arg POSITRON_UID=$$(( $(POSITRON_UID_BASE) + 1 )) \
		--build-arg POSITRON_GID=$$(( $(POSITRON_UID_BASE) + 1 )) \
		--build-arg JOB_RUNNER_UID=$$(( $(POSITRON_UID_BASE) + 2 )) \
		. || { rm -f $@; exit 1; }
	touch $@

image: .image-build
image: POSITRON_UID_BASE=50000

clean:
	rm -f .image-build $(CONTAINERFILE)
