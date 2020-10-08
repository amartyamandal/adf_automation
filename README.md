# adf_automation

- Azure Data factory is a nice offering from Microsoft, but there are few things needs to be sorted out.

  - How a team can collaborate, ADF provides a nice UI to design and link various services, but produced artifacts are in JSON and needs to be deployed through ARM template.
  There are static resources which you need for linked services, if pipeline make use of Azure Storage or Data brick those resources needs to be provisioned separately.

  - The pipeline itself consists of Activities, Functions, triggers, datasets etc. And ADF will create the underlying deployment / publish artifacts for the same, if you want you can incorporate the changes in IAC, but that will be an overhead to the CI/CD , everytime a new changes been made in designer UI, someone needs to manually check and incorporate the same in the IAC code and not all the linked services can be scripted this way.

  - Most of the demo's in the internet are using Azure Dev Ops, its a nice tool, but personally I would like to use GitHub workflow which is really easy and terraform for IAC as well as terraform cloud to maintain tfstate and collaborate through workspace.

Following video has all the explanation.
Follow the video to understand how the branch has been structured, all the secrets needs to be created based on your use case.
codes has placeholders like "<>" which means replace the same with your own values.
https://www.youtube.com/watch?v=ejqngEZ4Yno&feature=emb_logo
