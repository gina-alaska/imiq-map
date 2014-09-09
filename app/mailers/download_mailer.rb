class DownloadMailer < ActionMailer::Base
  default from: "support@gina.alaska.edu"
  
  def download_ready_email(export)
    @export = export
    @url = download_export_url(@export)
    mail(to: @export.email, subject: '[IMIQ] Download Ready')
  end
end
