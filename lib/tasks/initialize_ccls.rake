#encoding: utf-8 
desc 'initialize_ccls'
task :initialize_ccls => :environment do

  data = [
    "1|CC BY 4.0|http://creativecommons.org/licenses/by/4.0/deed.ko|<strong>저작자표시 라이선스</strong>: 이 라이선스는 저작자를 올바르게 밝히기만 하면 사람들이 해당 저작물을 심지어 상업적으로도 배포, 리믹스, 변경, 활용할 수 있도록 허락하는 라이선스입니다. 이 라이선스는 CC 라이선스 중 가장 허용 범위가 넓은 라이선스입니다. 저작물이 최대한 유통되고 이용되기를 바라는 경우에 추천합니다.",
    "2|CC BY-SA 4.0|http://creativecommons.org/licenses/by-sa/4.0/deed.ko|<strong>저작자표시-동일조건변경허락 라이선스</strong>: 이 라이선스는 저작자를 올바르게 밝히고 2차 저작물에도 동일한 라이선스를 적용할 경우 해당 저작물을 리믹스하거나 변경, 재가공할 수 있도록 허락하는 라이선스입니다. 이 라이선스는 종종 '카피레프트(Copyleft)'라 불리는 자유이용라이선스나 오픈소스 소프트웨어 라이선스와 비교되곤 합니다. 원저작물에 기초해 만들어지는 모든 새로운 2차 저작물에도 동일한 라이선스가 적용되며, 따라서 2차 저작물에 대해서도 역시 상업적 이용이 허락됩니다. 이 라이선스는 위키피디아에서 사용되는 라이선스로, 위키피디아 및 같은 라이선스를 사용한 프로젝트의 콘텐츠를 활용 편집해 이용하고자 하는 자료에 추천합니다.",
    "3|CC BY-ND 4.0|http://creativecommons.org/licenses/by-nd/4.0/deed.ko|<strong>저작자표시-변경금지 라이선스</strong>: 이 라이선스는 저작자를 표시하고 저작물이 수정 및 편집되지 않은 상태로 제공되는 한 상업적 및 비상업적 목적의 재배포를 모두 허락합니다.",
    "4|CC BY-NC 4.0|http://creativecommons.org/licenses/by-nc/4.0/deed.ko|<strong>저작자표시-비영리 라이선스</strong>: 이 라이선스는 비상업적 목적일 경우에 한해 저작물을 리믹스, 변경, 재가공하는 것을 허락합니다. 2차적 저작물은 반드시 원저작물의 저작자를 표시해야하며 마찬가지로 비상업적 용도로만 사용될 수 있지만, 2차적 저작물에도 반드시 동일한 라이선스를 적용할 필요는 없습니다.",
    "5|CC BY-NC-SA 4.0|http://creativecommons.org/licenses/by-nc-sa/4.0/deed.ko|<strong>저작자표시-비영리-동일조건변경허락 라이선스</strong>: 이 라이선스는 원저작물의 저작자를 밝히고 2차적 저작물에도 동일한 라이선스를 적용하는 한, 저작물을 비상업적 용도로 리믹스, 변경하거나 재가공하는 것을 허락합니다.",
    "6|CC BY-NC-ND 4.0|http://creativecommons.org/licenses/by-nc-nd/4.0/deed.ko|<strong>저작자표시-비영리-변경금지 라이선스</strong>: 이 라이선스는 6개 CC 라이선스 중 가장 제한이 많은 라이선스입니다. 원저작자를 밝히는 한 해당 저작물을 다운로드하고 공유하는 것만 허용되며, 어떠한 변경도 가할 수 없고 상업적으로 이용할 수도 없습니다."
  ]

  begin
    ActiveRecord::Base.transaction do
      data.each do |record|
        id, name, url, description = record.chomp.split("|")

        ccl = Ccl.find_by(id: id)
        if ccl.nil?
          Ccl.create!(id: id, name: name, url: url, description: description)
        else
          ccl.update!(name: name, url: url, description: description)
        end
      end
    end
  rescue => e
    puts "failed: #{e.to_s}"
  else
    puts "succeed"
  end
end
