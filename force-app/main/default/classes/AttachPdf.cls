global class AttachPdf implements Queueable, Database.AllowsCallouts{

    Set<Id> AccountIdSet=new Set<Id>();

    global AttachPdf(Set<Id> AccountIdSet) {
        this.AccountIdSet.addAll(AccountIdset); 
    }

    global void execute(QueueableContext ctx){
        
        Pagereference pdfPage;

        Attachment attachmentPdf;
        List<Attachment> attachmentPdfList = new List<Attachment>();

        for(Id accId: AccountIdSet){
            pdfPage = Page.AttachPDF_vf;
            pdfPage.getParameters().put('Id', accId);
            Blob pdf = pdfPage.getContentAsPDF();

            attachmentPdf = new Attachment();
            attachmentPdf.ParentId = accId;
            attachmentPdf.Name = accId+'.pdf';
            attachmentPdf.body = pdf;

            attachmentPdfList.add(attachmentPdf);

        }
        if(attachmentPdfList.size() > 0 ){
            //insert attachmentPdfList;
            Database.SaveResult[] srList = Database.insert(attachmentPdfList,false);
        }
    }

}
