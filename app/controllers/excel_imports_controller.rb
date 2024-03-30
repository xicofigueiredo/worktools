class ExcelImportsController < ApplicationController
  def new
    @excel_import = ExcelImport.new
  end

  def create
    @excel_import = ExcelImport.new(excel_import_params)

    if @excel_import.save
      redirect_to new_excel_import_path, notice: "Excel file is being processed."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def excel_import_params
    params.require(:excel_import).permit(:file)
    # Ensure :file matches your model's attached file name
  end
end
