# coding: utf-8
require 'nokogiri'

def scrape_user_page(file_content, charset = 'utf-8')
  doc = Nokogiri::HTML.parse(file_content, nil, charset)

  # TODO: company id

  # work experiences
  work_experiences = []
  doc.css('#user-profile-bottom div.column-main-inner > section.user-profile-section > h2:contains("Work experience")').first&.parent.css('ul li').each do |node|
    entry_title_node = node.css('.profile-entry-title span a').first
    org_path = entry_title_node.attribute('href')&.value
    org_id = /^\/org\/([0-9]+).*$/.match(org_path)[1]&.to_i
    entry_date_text = node.css('p.profile-entry-date span').first&.inner_text&.strip
    # FIXME: regex expression
    _, start_date, end_date = /^([0-9-]+)\s-\s([0-9-]+)/.match(entry_date_text)&.to_a
    work_experiences.push({
        org_id: org_id,
        start_date: start_date,
        end_date: end_date
    })
  end

  # schools
  schools = []
  doc.css('#user-profile-bottom div.column-main-inner > section.user-profile-section > h2:contains("Education")').first&.parent.css('ul li').each do |node|
    entry_title_node = node.css('.profile-entry-title span a').first
    school_path = entry_title_node.attribute('href')&.value
    school_id = /^\/schools\/([0-9]+).*$/.match(school_path)[1]&.to_i
    entry_date_text = node.css('p.profile-entry-date span').first&.inner_text&.strip
    # FIXME: regex expression
    _, start_date, end_date = /^([0-9-]+)\s-\s([0-9-]+)/.match(entry_date_text)&.to_a
    schools.push({
        school_id: school_id,
        start_date: start_date,
        end_date: end_date
    })
  end

  # what i'm good at
  skills = []
  doc.css('#user-profile-bottom div.column-main-inner > section.user-profile-section.skill-section > ul  h3.profile-entry-title').each do |node|
    skill_plus_votes = node.css('.skill-plus-button').inner_text&.to_i
    skill_node = node.css('a')
    skill_name = skill_node.inner_text
    skill_id = /^\/skill_tags\/([0-9]+).*$/.match(skill_node.attribute('href')&.value)[1]&.to_i
    skills.push({
        skill_plus_votes: skill_plus_votes,
        skill_name: skill_name,
        skill_id: skill_id
    })
  end

  # TODO: parse Portfolio
  # TODO: parse Projects
  # TODO: parse Courses
  # TODO: parse Publication
  # TODO: parse Certificates
  # TODO: parse Languages
  # TODO: parse Club/volunteering
  # TODO: parse Club/volunteering

  result = {
      work_experiences: work_experiences,
      schools: schools,
      skills: skills
  }
  return result
end

