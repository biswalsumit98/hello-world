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
            steps
            {
                echo 'Building...'
                sh 'mvn clean package'
            }
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
                        openshift.withProject("new-pro")
                        {
                            def buildConfigExists = openshift.selector("bc", "cicd").exists()
                            
                            if(!buildConfigExists)
                            {
                                openshift.newBuild("--name=cicd", "--docker-image=registry.redhat.io/openjdk/openjdk-11-rhel7", "--binary")
                            }
                            
                            openshift.selector("bc", "cicd").startBuild("--from-file=webapp/target/webapp.war", "--follow")
                            
                        }
                    }
                }
            }
        }
        
        
        
        
        stage('Deploy')
        {
            steps
            {
                echo 'Deploying....'
                script
                {
                    openshift.withCluster()
                    {
                        openshift.withProject("new-pro")
                        {
                            def deployment = openshift.selector("dc", "cicd")
                            
                            if(!deployment.exists())
                            {
                                openshift.newApp('cicd', "--as-deployment-config").narrow('svc').expose()
                            }
                            
                            timeout(5)
                            {
                                openshift.selector("dc", "cicd").related('pods').untilEach(1)
                                {
                                    return (it.object().status.phase == "Running")
                                }
                            }
                            
                            
                        }
                    }
                }
            }
        }
        
        
        
        
    }
    
    
}
