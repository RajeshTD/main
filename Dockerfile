FROM ppodgorsek/robot-framework:latest

USER root
WORKDIR /robot-tests

COPY . /robot-tests/
COPY parse_robot_results.py /robot-tests/

RUN chmod +x runner.sh
RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["./runner.sh"]