#这里我们想在哪几台机器上来运行kafka，需要对节点进行打标签。

kubectl label node [node-name] travis.io/schedule-only=kafka 
#当然，如果我们如果不想在哪些节点运行kafka，可以通过配置污点来进行。

kubectl taint node [node-name] travis.io/schedule-only=kafka:NoSchedule
