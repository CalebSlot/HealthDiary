cp -a build/web/. ../healthdiaryweb \
&& cd ../healthdiaryweb \
&& git add . \
&& git commit -m "$1" \
&& git push \
&& cd ../healthdiary \
&& echo -e "DONE";
