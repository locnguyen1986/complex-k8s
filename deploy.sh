echo '-------------------------------------------------------'
echo 'BUILD DOCKER IMAGES'
docker build -t locnguyen1986/complex-k8s-client:latest -t locnguyen1986/complex-k8s-client:$SHA -f ./client/Dockerfile ./client   
docker build -t locnguyen1986/complex-k8s-server:latest -t locnguyen1986/complex-k8s-server:$SHA -f ./server/Dockerfile ./server    
docker build -t locnguyen1986/complex-k8s-worker:latest -t locnguyen1986/complex-k8s-worker:$SHA -f ./worker/Dockerfile ./worker

echo '-------------------------------------------------------'
echo 'PUSH ALL IMAGES TO DOCKERHUB'
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_ID" --password-stdin
docker push locnguyen1986/complex-k8s-client:latest
docker push locnguyen1986/complex-k8s-server:latest
docker push locnguyen1986/complex-k8s-worker:latest
docker push locnguyen1986/complex-k8s-client:$SHA
docker push locnguyen1986/complex-k8s-server:$SHA
docker push locnguyen1986/complex-k8s-worker:$SHA

echo '-------------------------------------------------------'
echo 'APPLY CONFIG IN K8S'
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=locnguyen1986/complex-k8s-server:$SHA
kubectl set image deployments/client-deployment client=locnguyen1986/complex-k8s-client:$SHA
kubectl set image deployments/worker-deployment worker=locnguyen1986/complex-k8s-worker:$SHA