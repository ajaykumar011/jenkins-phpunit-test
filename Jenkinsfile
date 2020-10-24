pipeline {
    agent none
    stages {
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
        stage('Test app Deployment') {
                    agent any 
                    steps {
                        sh 'php -v || php --version'
                        sh 'ls -l `which php`'
                        sh 'chmod +x test-app-requirements.sh'
                        sh 'sudo ./test-app-requirements.sh'
                        //sh 'chmod +x test-app-install.sh'
                        //sh './test-app-install.sh'
                    }
        }
        stage('Run Tests') {
            parallel {
                stage('PHPLint') {
                    agent any // remove this and select php desired node
                    // agent {
                    //     label "windows"
                    // }
                    steps {
                        sh 'find src/ -name "*.php" -print0 | xargs -0 -n1 php7.3 -l'
                    }
                }
                stage('PHPUnit') {
                    agent any 
                    steps {
                       sh 'wget -O tools/phive https://phar.io/releases/phive.phar && chmod +x tools/phive'
                       sh 'php tools/phive install phpunit'
                       sh 'php tools/phpunit --log-junit results/phpunit/phpunit.xml -c tests/phpunit.xml'
                       archive (includes: 'pkg/*.*')
                                           }
                    post {
                        always {
                            echo "I am in PHPUnit Post section"
                          
                             junit([
                                allowEmptyResults: true,
                                keepLongStdio: true,
                                testResults: 'results/phpunit/phpunit.xml'
                             ])
                           
                            //publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'results/phpunit', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: ''])
                        }
                    }
                }

            }
        }
    }
} //pipeline closed








//  stage('publish reports') {
//         steps {
//             unstash 'source'

//             script {
//                 sh 'ls target/jmeter/reports > listFiles.txt'
//                 def files = readFile("listFiles.txt").split("\\r?\\n");
//                 sh 'rm -f listFiles.txt'

//                 for (i = 0; i < files.size(); i++) {
//                     publishHTML target: [
//                         allowMissing:false,
//                         alwaysLinkToLastBuild: false,
//                         keepAll:true,
//                         reportDir: 'target/jmeter/reports/' + files[i],
//                         reportFiles: 'index.html',
//                         reportName: files[i]
//                     ]
//                 }                   
//             }           
      










