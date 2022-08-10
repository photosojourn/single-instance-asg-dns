FROM public.ecr.aws/lambda/python:3.9

# Copy function code
COPY lambda.py ${LAMBDA_TASK_ROOT}

# Install the function's dependencies using file requirements.txt from your project folder.
COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN  pip3 install --no-cache-dir -r requirements.txt --target "${LAMBDA_TASK_ROOT}"

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "lambda_function.lambda_handler" ]
