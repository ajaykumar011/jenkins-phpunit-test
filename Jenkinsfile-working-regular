pipeline {
 agent any
 options {
        timeout(time: 1, unit: 'HOURS') 
        timestamps() 
        buildDiscarder(logRotator(numToKeepStr: '5'))
        //skipDefaultCheckout() //skips the default checkout.
        //checkoutToSubdirectory('subdirectory') //checkout to a subdirectory
        // preserveStashes()   Preserve stashes from completed builds, for use with stage restarting
        }

 environment {
        FULL_PATH_BRANCH = "${sh(script:'git name-rev --name-only HEAD', returnStdout: true)}"
        GIT_BRANCH = FULL_PATH_BRANCH.substring(FULL_PATH_BRANCH.lastIndexOf('/') + 1, FULL_PATH_BRANCH.length())
        }
 parameters {       
    booleanParam(name: 'autoApprove1', defaultValue: false, description: 'Phpunit') 
    booleanParam(name: 'autoApprove2', defaultValue: false, description: 'Automatically deploy application?')
        }

     
  stages {
        stage('Checkout') {
            steps {
                script{
                    //git branch: 'Your Branch name', credentialsId: 'Your crendiatails', url: ' Your BitBucket Repo URL '
                    // Branch name is master in this repo
                    //git branch: 'main', credentialsId: 'github-cred', url: 'https://github.com/ajaykumar011/jenkins-packer-with-ansible2/'
                    echo 'Pulling... ' + env.GIT_BRANCH
                    sh 'printenv'
                   //sh "ls -la ${pwd()}"   # this is working but not needed
                   sh "tree ${env.WORKSPACE}" 
                }
            }
        }

    stage('BuildInfo') {
            steps {
                    echo "Running Buid num: ${env.BUILD_ID} on Jenkins ${env.JENKINS_URL}"
                    echo "BUILD_NUMBER :: ${env.BUILD_NUMBER}"
                    echo "BUILD_ID :: ${env.BUILD_ID}"
                    echo "BUILD_DISPLAY_NAME :: ${env.BUILD_DISPLAY_NAME}"
                    echo "JOB_NAME :: ${env.JOB_NAME}"
                    echo "JOB_BASE_NAME :: ${env.JOB_BASE_NAME}"
                    echo "BUILD_TAG :: ${env.BUILD_TAG}"
                    echo "EXECUTOR_NUMBER :: ${env.EXECUTOR_NUMBER}"
                    echo "NODE_NAME :: ${env.NODE_NAME}"
                    echo "NODE_LABELS :: ${env.NODE_LABELS}"
                    echo "WORKSPACE :: ${env.WORKSPACE}"
                    echo "JENKINS_HOME :: ${env.JENKINS_HOME}"
                    echo "JENKINS_URL :: ${env.JENKINS_URL}"
                    echo "BUILD_URL ::${env.BUILD_URL}"
                    echo "JOB_URL :: ${env.JOB_URL}"
    
                }
            }

        stage('PHP information') {
            steps {
            sh 'php -v || php --version'
            sh 'ls -l `which php`'
            }
        }
        stage('Requirements Install') {
            steps {
            sh 'chmod +x test-app-requirements.sh'
            sh 'sudo ./test-app-requirements.sh'
            }
        }

        stage('App Test Install') {
            steps {
            sh 'chmod +x test-app-install.sh'
            sh './test-app-install.sh'
            }
        }
        
        stage("PHPLint") {
            steps {
            sh 'find src/ -name "*.php" -print0 | xargs -0 -n1 php7.3 -l'
            }
        }
        
        stage("Lines of Code") {
            steps {
            sh 'php tools/phploc --count-tests --log-csv logs/phploc.csv --log-xml logs/phploc.xml src/ test/'
            }
        }
        
        stage("Software metrics") {
            steps {
            sh 'php vendor/bin/pdepend --jdepend-xml=logs/jdepend.xml --jdepend-chart=pdepend/dependencies.svg --overview-pyramid=pdepend/overview-pyramid.svg src/'
            }
        }
        
        stage("Mess Detection Report") {
            steps {
            sh 'php vendor/bin/phpmd src/ xml phpmd.xml --reportfile logs/pmd.xml'
            }
        }
        
        stage("Checkstyle Report") {
            steps {
            sh 'php tools/phpcs --report=checkstyle --standard=phpcs.xml --report-file=logs/checkstyle.xml --extensions=php src/'
            }
        }        
        
        stage("CPD Report ") {
            steps {
            sh 'php tools/phpcpd --log-pmd logs/pmd-cpd.xml --names-exclude "*Test.php" src/'
            }
        }
        
        stage("PHPUnit") {
            steps {
            sh 'php tools/phpunit -c phpunit.xml'
            }
        }
        
        stage("Generate documentation") {
            steps {
            sh 'php tools/phpdox -f phpdox.xml'
            }
        }
        stage("PSALM Error Tracming") {
            steps {
            sh 'composer require --dev vimeo/psalm'
            sh './vendor/bin/psalm --init'
            sh './vendor/bin/psalm'
            }
        }

        stage("PHPBU backup") {
            steps {
            sh 'php tools/phpbu.phar --version'
            echo "PHPBU is a php tool that creates and encrypts backups, syncs your backups to other servers or cloud services and assists you monitor your backup creation."
            }
        }

        stage("PHPSTAN Code Analysis") {
            steps {
            sh 'php tools/phpstan.phar --version'
            echo "nothing doing here."
            }
        }
        stage("PHPing") {
            steps {
            sh 'php tools/phing.phar -version'
            echo "PHPUnit unit tests (including test result and coverage reports), file transformations, file system operations, interactive build support"
            echo "SQL execution, Git/Subversion operations, documentation generation (PhpDocumentor, ApiGen)"
            }
        }
    
  }  //stage closed

    post {
            always {
                echo 'One way or another, I have finished'
                // deleteDir() /* delete the working dir normally workspace */
                //cleanWs() /* clean up workspace */
                //archiveArtifacts artifacts: 'targetbuild-*.zip', followSymlinks: false, onlyIfSuccessful: true
                }
        
            success {
                 echo 'Success'
                // slackSend channel: '#jenkins-builds',
                // color: 'good',
                // message: "The pipeline ${currentBuild.fullDisplayName} completed successfully."
                }
                  
            unstable {
                echo 'I am unstable :/'
                }
        
            failure {
                echo 'delete me I am of no use'
                //cleanWs()
                //  mail to: 'ajay011.sharma@hotmail.com',
                //  cc: 'macme.tang@gmail.com',
                //  subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
                //  body: "Something is wrong with ${env.BUILD_URL}"
                }
            changed {
                echo 'Things were different before...'
                }   
        } 
    //post closed
} //pipeline closed