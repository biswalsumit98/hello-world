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
                        openshift.withProject("pipeline-lb9669-dev")
                        {
                            def bc = openshift.selector("bc", "calculator").exists()
                        
                            if(!bc)
                             {
                                openshift.newBuild("--name=calculator", "--docker-image=docker.hub/sumitbiswal98/regapp", "--binary")
                             }
                        
                                openshift.selector("bc", "calculator").startBuild("--from-file=target/webapp.war", "--follow")
                        
                        
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
                        openshift.withProject("pipeline-lb9669-dev")
                        {
                            def deployment = openshift.selector("dc", "calculator")
                            
                            if(!deployment.exist())
                            {
                                openshift.newApp('calculator', "--as-deployment-config").narrow('svc').expose()
                            }
                            
                            timeout(5)
                            {
                                openshift.selector("dc", "calculator").related('pods').untilEach(1)
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
