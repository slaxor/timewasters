all:
	@echo 'targets: me a sandwich'

me a:
	@true

sandwich.:
	@if [ ${USER} = root ] ; then echo 'Okay.'; \
	else echo 'What? Make it yourself.'; \
	fi


