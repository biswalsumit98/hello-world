pipeline
{
    agent
    {
        label 'maven'
    }
    
    
    
    
    
    stages
    {
        
        stage('Build')
        {
            echo 'Building...'
            sh 'mvn clean package'
        }
        
        
        stage('Create Container Image')
        {
            steps
            {
                echo 'create container image..'
                script
                {
                    openshift.withCluster()
                    {
                        openshift.withProject("ci-cd")
                        {
                            def bc = openshift.selector("bc", "hello-world").exists()
                        
                            if(!bc)
                             {
                                openshift.newBuild("--name=hello-world", "--docker-image=docker.hub/sumitbiswal98/regapp", "--binary")
                             }
                        
                                openshift.selector("bc", "hello-world").startBuild("--from-file=target/webapp.war", "--follow")
                        
                        
                        }
                    }
                }
            }
        }
        
        
        stage('Deploy')
        {
            steps
            {
                echo 'Deploying...'
                script
                {
                    openshift.withCluster()
                    {
                        openshift.withProject("ci-cd")
                        {
                            def deployment = openshift.selector("dc", "hello-world")
                            
                            if(!deployment.exist())
                            {
                                openshift.newApp('hello-world', "--as-deployment-config").narrow('svc').expose()
                            }
                            
                            timeout(5)
                            {
                                openshift.selector("dc", "hello-world").related('pods').untilEach(1)
                                {
                                    return(it.object().status.phase == "Running")
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        
        
        
        
        
        
        
    }
    
    
}
