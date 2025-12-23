class CertificateRequest < ServiceRequest
  validates :certificate_type, presence: true
end
